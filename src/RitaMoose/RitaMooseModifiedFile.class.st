"
I am the kind of change of a file whose content is modified by the commit.
"
Class {
	#name : 'RitaMooseModifiedFile',
	#superclass : 'RitaMooseFileChangeKind',
	#category : 'RitaMoose',
	#package : 'RitaMoose'
}

{ #category : 'accessing' }
RitaMooseModifiedFile class >> description [

	^ 'Modified'
]

{ #category : 'testing' }
RitaMooseModifiedFile class >> isFor: aGLHDiff [

	^ aGLHDiff new_file not and: [ aGLHDiff deleted_file not and: [ aGLHDiff renamed_file not ] ]
]

{ #category : 'testing' }
RitaMooseModifiedFile class >> isModified [

	^ true
]
