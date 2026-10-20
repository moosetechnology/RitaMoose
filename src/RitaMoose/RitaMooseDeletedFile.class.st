"
I am the kind of change of a file removed by the commit.
"
Class {
	#name : 'RitaMooseDeletedFile',
	#superclass : 'RitaMooseFileChangeKind',
	#category : 'RitaMoose',
	#package : 'RitaMoose'
}

{ #category : 'accessing' }
RitaMooseDeletedFile class >> description [

	^ 'Deleted'
]

{ #category : 'testing' }
RitaMooseDeletedFile class >> isDeleted [

	^ true
]

{ #category : 'testing' }
RitaMooseDeletedFile class >> isFor: aGLHDiff [

	^ aGLHDiff deleted_file
]
