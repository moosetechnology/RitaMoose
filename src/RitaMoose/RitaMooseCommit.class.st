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
RitaMooseCommit >> id [

	^ glhCommit id
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
		nextPutAll: self id
]

{ #category : 'accessing' }
RitaMooseCommit >> sha [

	^ glhCommit id
]

{ #category : 'accessing' }
RitaMooseCommit >> shortSha [

	^ glhCommit short_id
]
