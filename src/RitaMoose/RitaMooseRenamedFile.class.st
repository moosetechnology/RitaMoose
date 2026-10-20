"
I am the kind of change of a file moved or renamed by the commit.
"
Class {
	#name : 'RitaMooseRenamedFile',
	#superclass : 'RitaMooseFileChangeKind',
	#category : 'RitaMoose',
	#package : 'RitaMoose'
}

{ #category : 'accessing' }
RitaMooseRenamedFile class >> description [

	^ 'Renamed'
]

{ #category : 'testing' }
RitaMooseRenamedFile class >> isFor: aGLHDiff [

	^ aGLHDiff renamed_file
]

{ #category : 'testing' }
RitaMooseRenamedFile class >> isRenamed [

	^ true
]
