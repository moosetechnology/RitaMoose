"
I am the abstract strategy for a programming language: I say which file paths I accept and how to build a FAST model from a source text. Subclasses implement #acceptsPath: and #modelFromSource:.
"
Class {
	#name : 'RitaMooseLanguage',
	#superclass : 'Object',
	#category : 'RitaMoose',
	#package : 'RitaMoose'
}

{ #category : 'accessing' }
RitaMooseLanguage >> acceptsPath: aPath [

	^ self subclassResponsibility
]

{ #category : 'accessing' }
RitaMooseLanguage >> modelFromSource: aSource [

	^ self subclassResponsibility
]
