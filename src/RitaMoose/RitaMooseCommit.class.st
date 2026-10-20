"
I am a commit of a repository analysed by RitaMoose. I wrap a GitProjectHealth commit, which stays private.
"
Class {
	#name : 'RitaMooseCommit',
	#superclass : 'Object',
	#instVars : [
		'glhCommit'
	],
	#category : 'RitaMoose',
	#package : 'RitaMoose'
}

{ #category : 'instance creation' }
RitaMooseCommit class >> on: aGLHCommit [

	^ self new
		  glhCommit: aGLHCommit;
		  yourself
]

{ #category : 'accessing' }
RitaMooseCommit >> author [

	^ glhCommit author_name
]

{ #category : 'accessing' }
RitaMooseCommit >> date [

	^ glhCommit authored_date
]

{ #category : 'private' }
RitaMooseCommit >> glhCommit [

	^ glhCommit
]

{ #category : 'private' }
RitaMooseCommit >> glhCommit: aGLHCommit [

	glhCommit := aGLHCommit
]

{ #category : 'accessing' }
RitaMooseCommit >> message [

	^ glhCommit message
]

{ #category : 'accessing' }
RitaMooseCommit >> parentShas [

	^ glhCommit parent_ids ifNil: [ #(  ) ]
]

{ #category : 'printing' }
RitaMooseCommit >> printOn: aStream [

	aStream
		nextPutAll: 'RitaMooseCommit ';
		nextPutAll: self shortSha.
	self message ifNotNil: [ :text |
			aStream
				nextPutAll: ' ';
				nextPutAll: (text lines ifEmpty: [ '' ] ifNotEmpty: [ :lines | lines first ]) ]
]

{ #category : 'accessing' }
RitaMooseCommit >> sha [

	^ glhCommit id
]

{ #category : 'accessing' }
RitaMooseCommit >> shortSha [
	"I don't like this, but this is due to https://github.com/moosetechnology/GitProjectHealth/issues/290"

	^ glhCommit id first: 7
]
