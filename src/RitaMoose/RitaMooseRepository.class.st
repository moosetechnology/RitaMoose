"
I am the entry point of RitaMoose to read a Git repository hosted on GitHub. I hide GitProjectHealth: I import the project and its commits, and I give back RitaMooseCommit objects and RitaMooseCommitModels (FAST models before/after a commit).
"
Class {
	#name : 'RitaMooseRepository',
	#superclass : 'Object',
	#instVars : [
		'glhModel',
		'importer',
		'glhProject',
		'language'
	],
	#classVars : [
		'Token'
	],
	#category : 'RitaMoose',
	#package : 'RitaMoose'
}

{ #category : 'instance creation' }
RitaMooseRepository class >> owner: anOwner name: aName [
	"Import the GitHub project and prepare the analysis of its commits. The token must be set with #token:"

	^ self new
		  initializeOwner: anOwner name: aName;
		  yourself
]

{ #category : 'token' }
RitaMooseRepository class >> resetToken [
	"Forget the GitHub token of the session"

	<script>
	Token := nil
]

{ #category : 'accessing' }
RitaMooseRepository class >> token [
	"GitHub token shared by all the repositories of the session"

	^ Token
]

{ #category : 'accessing' }
RitaMooseRepository class >> token: aString [
	"Set the GitHub token once for the session"

	Token := aString
]

{ #category : 'private' }
RitaMooseRepository >> accepts: aPath [

	^ aPath isNotNil and: [ language acceptsPath: aPath ]
]

{ #category : 'analysis' }
RitaMooseRepository >> changedFilesOf: aRitaMooseCommit [
	"Files changed by aRitaMooseCommit, whatever their language, with their change kind. The file contents are not fetched."

	^ (self diffsOf: aRitaMooseCommit glhCommit) collect: [ :diff | RitaMooseChangedFile fromDiff: diff ]
]

{ #category : 'accessing' }
RitaMooseRepository >> commitWithSha: aSha [

	^ self commits detect: [ :each | each sha = aSha ]
]

{ #category : 'accessing' }
RitaMooseRepository >> commits [
	"All the commits of the project, as RitaMooseCommit"

	importer importCommitsOfProject: glhProject.
	^ glhProject repository commits collect: [ :each | RitaMooseCommit on: each ]
]

{ #category : 'private' }
RitaMooseRepository >> decodeContent: aResponse [
	"GitHub returns the file content in base64, with line endings"

	| json base64 |
	json := NeoJSONReader fromString: aResponse.
	base64 := (json at: 'content') reject: [ :each | each = Character cr or: [ each = Character lf ] ].
	^ (Base64MimeConverter mimeDecodeToChars: base64 readStream) contents
]

{ #category : 'private' }
RitaMooseRepository >> diffsOf: aGLHCommit [

	^ importer importDiffOfCommit: aGLHCommit
]

{ #category : 'initialization' }
RitaMooseRepository >> initializeOwner: anOwner name: aName [

	glhModel := GLHModel new name: aName.
	importer := GithubModelImporter new
		            glhModel: glhModel;
		            privateToken: (self class token ifNil: [ self error: 'Set the token first: RitaMooseRepository token: ''ghp_...''' ]);
		            yourself.
	glhProject := importer importProject: aName ofGroup: anOwner.
	self flag: #todo. "Do not hardcode a language"
	language := RitaMooseJavaLanguage new
]

{ #category : 'accessing' }
RitaMooseRepository >> language: aRitaMooseLanguage [

	language := aRitaMooseLanguage
]

{ #category : 'private' }
RitaMooseRepository >> modelOf: aPath atRef: aSha [

	^ language modelFromSource: (self sourceOf: aPath atRef: aSha)
]

{ #category : 'analysis' }
RitaMooseRepository >> modelsFor: aRitaMooseCommit [
	"Build the FAST models of the files changed by aRitaMooseCommit: before (in its first parent) and after (in the commit).
	Only the files accepted by the language are parsed."

	| parentSha before after |
	parentSha := aRitaMooseCommit parentShas
		             ifNotEmpty: [ :shas | shas first ]
		             ifEmpty: [ nil ].
	before := Dictionary new.
	after := Dictionary new.
	(self diffsOf: aRitaMooseCommit glhCommit) do: [ :diff |
			(parentSha notNil and: [ diff new_file ~= true and: [ self accepts: diff old_path ] ]) ifTrue: [ before at: diff old_path put: (self modelOf: diff old_path atRef: parentSha) ].
			(diff deleted_file ~= true and: [ self accepts: diff new_path ]) ifTrue: [ after at: diff new_path put: (self modelOf: diff new_path atRef: aRitaMooseCommit sha) ] ].
	^ RitaMooseCommitModels new
		  commit: aRitaMooseCommit;
		  parentSha: parentSha;
		  before: before;
		  after: after;
		  yourself
]

{ #category : 'private' }
RitaMooseRepository >> sourceOf: aPath atRef: aSha [
	"Text of the file aPath at the commit aSha, read through the GitHub contents API"

	| response |
	response := importer repoApi contents
		            getContent: aPath
		            forRepo: glhProject name
		            ofOwner: glhProject group name
		            onBranchRef: aSha.
	^ self decodeContent: response
]
