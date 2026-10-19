"
I test RitaMooseRepository without network: diffs and file contents are provided by the test itself (see #diffsOf: and #sourceOf:atRef: below).
"
Class {
	#name : 'RitaMooseRepositoryTest',
	#superclass : 'TestCase',
	#instVars : [
		'repository'
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
	repository := RitaMooseFakeRepository new
		              language: RitaMooseJavaLanguage new;
		              yourself
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
