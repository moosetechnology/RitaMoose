"
I test RitaMooseRepository without network: diffs and file contents are provided by the test itself (see #diffsOf: and #sourceOf:atRef: below).
"
Class {
	#name : 'RitaMooseRepositoryTest',
	#superclass : 'TestCase',
	#instVars : [
		'repository',
		'oldToken'
	],
	#category : 'RitaMoose-Tests',
	#package : 'RitaMoose-Tests'
}

{ #category : 'helpers' }
RitaMooseRepositoryTest >> commitWithParents: aCollection [

	^ RitaMooseCommit on: (GLHCommit new
			   id: 'c2';
			   short_id: 'c2';
			   parent_ids: aCollection;
			   yourself)
]

{ #category : 'helpers' }
RitaMooseRepositoryTest >> diffFrom: anOldPath to: aNewPath added: anAddedBoolean deleted: aDeletedBoolean [

	^ GLHDiff new
		  old_path: anOldPath;
		  new_path: aNewPath;
		  new_file: anAddedBoolean;
		  deleted_file: aDeletedBoolean;
		  yourself
]

{ #category : 'running' }
RitaMooseRepositoryTest >> setUp [

	super setUp.
	oldToken := RitaMooseRepository token.
	repository := RitaMooseFakeRepository new
		              language: RitaMooseJavaLanguage new;
		              yourself
]

{ #category : 'running' }
RitaMooseRepositoryTest >> tearDown [

	RitaMooseRepository token: oldToken.
	super tearDown
]

{ #category : 'tests' }
RitaMooseRepositoryTest >> testAddedJavaFileIsOnlyAfter [

	| models |
	repository
		diffs: { (self
				 diffFrom: nil
				 to: 'B.java'
				 added: true
				 deleted: false) };
		sources: (Dictionary new
				 at: 'B.java@c2' put: 'class B {}';
				 yourself).
	models := repository modelsFor: (self commitWithParents: #( 'c1' )).
	self assert: models before isEmpty.
	self assert: models after keys asArray equals: #( 'B.java' )
]

{ #category : 'tests' }
RitaMooseRepositoryTest >> testChangedFilePrintString [

	| changedFile |
	changedFile := RitaMooseChangedFile fromDiff: (self
			                diffFrom: 'README.md'
			                to: 'README.md'
			                added: false
			                deleted: false).
	self assert: changedFile printString equals: 'Modified README.md'
]

{ #category : 'tests' }
RitaMooseRepositoryTest >> testChangedFileStoresAChangeKindObject [

	| changedFile |
	changedFile := RitaMooseChangedFile fromDiff: (self
			                diffFrom: nil
			                to: 'B.java'
			                added: true
			                deleted: false).
	self assert: changedFile kind equals: RitaMooseAddedFile
]

{ #category : 'tests' }
RitaMooseRepositoryTest >> testChangedFilesOfRootCommit [

	repository diffs: { (self
			 diffFrom: nil
			 to: 'D.java'
			 added: true
			 deleted: false) }.
	self assert: (repository changedFilesOf: (self commitWithParents: #(  ))) first isAdded
]

{ #category : 'tests' }
RitaMooseRepositoryTest >> testChangedFilesReportTheKindOfEachChange [

	| changedFiles renamed |
	renamed := self
		           diffFrom: 'old.java'
		           to: 'new.java'
		           added: false
		           deleted: false.
	renamed renamed_file: true.
	repository diffs: {
			(self
				 diffFrom: nil
				 to: 'B.java'
				 added: true
				 deleted: false).
			(self
				 diffFrom: 'C.java'
				 to: nil
				 added: false
				 deleted: true).
			renamed.
			(self
				 diffFrom: 'README.md'
				 to: 'README.md'
				 added: false
				 deleted: false) }.
	changedFiles := repository changedFilesOf: (self commitWithParents: #( 'c1' )).
	self assert: changedFiles size equals: 4.
	self assert: changedFiles first isAdded.
	self assert: changedFiles first path equals: 'B.java'.
	self assert: changedFiles second isDeleted.
	self assert: changedFiles second path equals: 'C.java'.
	self assert: changedFiles third isRenamed.
	self assert: changedFiles third path equals: 'new.java'.
	self assert: changedFiles third oldPath equals: 'old.java'.
	self assert: changedFiles fourth isModified.
	self assert: changedFiles fourth path equals: 'README.md'
]

{ #category : 'tests' }
RitaMooseRepositoryTest >> testCommitPrintStringShowsShortShaAndFirstLine [

	| commit |
	commit := RitaMooseCommit on: (GLHCommit new
			           id: '703e9592772fa9ea14ce142d51d4eeb5d860de0a';
			           message: 'Fix the parser' , String cr , 'with details';
			           yourself).
	self assert: commit printString equals: 'RitaMooseCommit 703e959 Fix the parser'
]

{ #category : 'tests' }
RitaMooseRepositoryTest >> testDecodeContentFromGitHubResponse [

	self assert: (repository decodeContent: '{"content":"Y2xhc3MgQSB7fQ==\n","encoding":"base64"}') equals: 'class A {}'
]

{ #category : 'tests' }
RitaMooseRepositoryTest >> testDeletedJavaFileIsOnlyBefore [

	| models |
	repository
		diffs: { (self
				 diffFrom: 'C.java'
				 to: nil
				 added: false
				 deleted: true) };
		sources: (Dictionary new
				 at: 'C.java@c1' put: 'class C {}';
				 yourself).
	models := repository modelsFor: (self commitWithParents: #( 'c1' )).
	self assert: models before keys asArray equals: #( 'C.java' ).
	self assert: models after isEmpty
]

{ #category : 'tests' }
RitaMooseRepositoryTest >> testJavaLanguageAcceptsOnlyJavaFiles [

	self assert: (RitaMooseJavaLanguage new acceptsPath: 'src/A.java').
	self deny: (RitaMooseJavaLanguage new acceptsPath: 'src/A.txt')
]

{ #category : 'tests' }
RitaMooseRepositoryTest >> testModifiedJavaFileIsParsedBeforeAndAfter [

	| models |
	repository
		diffs: { (self
				 diffFrom: 'A.java'
				 to: 'A.java'
				 added: false
				 deleted: false) };
		sources: (Dictionary new
				 at: 'A.java@c1' put: 'class A {}';
				 at: 'A.java@c2' put: 'class A { int x; }';
				 yourself).
	models := repository modelsFor: (self commitWithParents: #( 'c1' )).
	self assert: models parentSha equals: 'c1'.
	self assert: models before keys asArray equals: #( 'A.java' ).
	self assert: models after keys asArray equals: #( 'A.java' ).
	self assert: ((models before at: 'A.java') isKindOf: FASTJavaModel)
]

{ #category : 'tests' }
RitaMooseRepositoryTest >> testNonJavaFilesAreIgnored [

	| models |
	repository diffs: { (self
			 diffFrom: 'README.md'
			 to: 'README.md'
			 added: false
			 deleted: false) }.
	models := repository modelsFor: (self commitWithParents: #( 'c1' )).
	self assert: models before isEmpty.
	self assert: models after isEmpty
]

{ #category : 'tests' }
RitaMooseRepositoryTest >> testRepositoryCannotBeCreatedWithoutToken [

	self should: [ RitaMooseRepository owner: 'moosetechnology' name: 'VerveineJ' ] raise: Error
]

{ #category : 'tests' }
RitaMooseRepositoryTest >> testRootCommitHasNoBefore [

	| models |
	repository
		diffs: { (self
				 diffFrom: nil
				 to: 'D.java'
				 added: true
				 deleted: false) };
		sources: (Dictionary new
				 at: 'D.java@c2' put: 'class D {}';
				 yourself).
	models := repository modelsFor: (self commitWithParents: #(  )).
	self assert: models parentSha isNil.
	self assert: models before isEmpty.
	self assert: models after keys asArray equals: #( 'D.java' )
]
