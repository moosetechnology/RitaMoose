"
I hold the FAST models of the files changed by a commit: before (in the parent commit) and after (in the commit). Each side is a dictionary from path to FASTJavaModel.
"
Class {
	#name : 'RitaMooseCommitModels',
	#superclass : 'Object',
	#instVars : [
		'commit',
		'before',
		'after',
		'parentSha'
	],
	#category : 'RitaMoose',
	#package : 'RitaMoose'
}

{ #category : 'accessing' }
RitaMooseCommitModels >> after [
	"Path to FASTJavaModel of the changed files in the commit"

	^ after
]

{ #category : 'accessing' }
RitaMooseCommitModels >> after: aDictionary [

	after := aDictionary
]

{ #category : 'accessing' }
RitaMooseCommitModels >> before [
	"Path to FASTJavaModel of the changed files in the parent commit"

	^ before
]

{ #category : 'accessing' }
RitaMooseCommitModels >> before: aDictionary [

	before := aDictionary
]

{ #category : 'accessing' }
RitaMooseCommitModels >> changedPaths [
	"Paths of the files changed by the commit, sorted"

	^ (before keys asSet
		   addAll: after keys;
		   yourself) asSortedCollection asArray
]

{ #category : 'accessing' }
RitaMooseCommitModels >> commit [

	^ commit
]

{ #category : 'accessing' }
RitaMooseCommitModels >> commit: aRitaMooseCommit [

	commit := aRitaMooseCommit
]

{ #category : 'accessing' }
RitaMooseCommitModels >> parentSha [

	^ parentSha
]

{ #category : 'accessing' }
RitaMooseCommitModels >> parentSha: aSha [

	parentSha := aSha
]
