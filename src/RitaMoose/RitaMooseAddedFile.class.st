"
I am the kind of change of a file created by the commit.
"
Class {
	#name : 'RitaMooseAddedFile',
	#superclass : 'RitaMooseFileChangeKind',
	#category : 'RitaMoose',
	#package : 'RitaMoose'
}

{ #category : 'accessing' }
RitaMooseAddedFile class >> description [

	^ 'Added'
]

{ #category : 'testing' }
RitaMooseAddedFile class >> isAdded [

	^ true
]

{ #category : 'testing' }
RitaMooseAddedFile class >> isFor: aGLHDiff [

	^ aGLHDiff new_file
]
