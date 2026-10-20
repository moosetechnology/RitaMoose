"
I am a file changed by a commit, with its change kind: #added, #deleted, #renamed or #modified. I do not parse the file, I only describe the change.
"
Class {
	#name : 'RitaMooseChangedFile',
	#superclass : 'Object',
	#instVars : [
		'path',
		'oldPath',
		'kind'
	],
	#category : 'RitaMoose',
	#package : 'RitaMoose'
}

{ #category : 'instance creation' }
RitaMooseChangedFile class >> fromDiff: aGLHDiff [
	"Build the changed file from a GitHub diff"

	^ self new
		  path: (aGLHDiff new_path ifNil: [ aGLHDiff old_path ]);
		  oldPath: aGLHDiff old_path;
		  kind: (RitaMooseFileChangeKind kindFor: aGLHDiff);
		  yourself
]

{ #category : 'testing' }
RitaMooseChangedFile >> isAdded [

	^ kind isAdded
]

{ #category : 'testing' }
RitaMooseChangedFile >> isDeleted [

	^ kind isDeleted
]

{ #category : 'testing' }
RitaMooseChangedFile >> isModified [

	^ kind isModified
]

{ #category : 'testing' }
RitaMooseChangedFile >> isRenamed [

	^ kind isRenamed
]

{ #category : 'accessing' }
RitaMooseChangedFile >> kind [
	"RitaMooseChangeKind subclass describing the change"

	^ kind
]

{ #category : 'accessing' }
RitaMooseChangedFile >> kind: aRitaMooseChangeKind [

	kind := aRitaMooseChangeKind
]

{ #category : 'accessing' }
RitaMooseChangedFile >> oldPath [

	^ oldPath
]

{ #category : 'accessing' }
RitaMooseChangedFile >> oldPath: aString [

	oldPath := aString
]

{ #category : 'accessing' }
RitaMooseChangedFile >> path [

	^ path
]

{ #category : 'accessing' }
RitaMooseChangedFile >> path: aString [

	path := aString
]

{ #category : 'printing' }
RitaMooseChangedFile >> printOn: aStream [

	aStream
		nextPutAll: kind description;
		space;
		nextPutAll: path
]
