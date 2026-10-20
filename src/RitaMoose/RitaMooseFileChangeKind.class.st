"
I am the abstract kind of change of a file in a commit. My subclasses (added, deleted, renamed, modified) answer the testing messages, and each one prints its own description.
"
Class {
	#name : 'RitaMooseFileChangeKind',
	#superclass : 'Object',
	#category : 'RitaMoose',
	#package : 'RitaMoose'
}

{ #category : 'accessing' }
RitaMooseFileChangeKind class >> description [
	"Word describing the change, used when printing"

	| newInstance |
	newInstance := self new.

	^ newInstance subclassResponsibility
]

{ #category : 'testing' }
RitaMooseFileChangeKind class >> isAdded [

	^ false
]

{ #category : 'testing' }
RitaMooseFileChangeKind class >> isDeleted [

	^ false
]

{ #category : 'testing' }
RitaMooseFileChangeKind class >> isFor: aGLHDiff [

	^ self subclassResponsibility
]

{ #category : 'testing' }
RitaMooseFileChangeKind class >> isModified [

	^ false
]

{ #category : 'testing' }
RitaMooseFileChangeKind class >> isRenamed [

	^ false
]

{ #category : 'accessing' }
RitaMooseFileChangeKind class >> kindFor: aGLHDiff [

	^ self allSubclasses detect: [ :class | class isFor: aGLHDiff ]
]
