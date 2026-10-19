"
I replace the GitHub access of RitaMooseRepository in tests: diffs are given as GLHDiff, file contents as a dictionary from 'path@sha' to source.
"
Class {
	#name : 'RitaMooseFakeRepository',
	#superclass : 'RitaMooseRepository',
	#instVars : [
		'diffs',
		'sources'
	],
	#category : 'RitaMoose-Tests',
	#package : 'RitaMoose-Tests'
}

{ #category : 'accessing' }
RitaMooseFakeRepository >> diffs: aCollection [

	diffs := aCollection
]

{ #category : 'private' }
RitaMooseFakeRepository >> diffsOf: aGLHCommit [

	^ diffs
]

{ #category : 'private' }
RitaMooseFakeRepository >> sourceOf: aPath atRef: aSha [

	^ sources at: aPath , '@' , aSha
]

{ #category : 'accessing' }
RitaMooseFakeRepository >> sources: aDictionary [

	sources := aDictionary
]
