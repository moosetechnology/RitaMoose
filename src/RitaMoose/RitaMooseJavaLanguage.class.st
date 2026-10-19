"
I am the Java strategy: I accept .java files and build a FASTJavaModel with the JavaSmaCCProgramNodeImporterVisitor.
"
Class {
	#name : 'RitaMooseJavaLanguage',
	#superclass : 'RitaMooseLanguage',
	#category : 'RitaMoose',
	#package : 'RitaMoose'
}

{ #category : 'accessing' }
RitaMooseJavaLanguage >> acceptsPath: aPath [

	^ aPath endsWith: '.java'
]

{ #category : 'accessing' }
RitaMooseJavaLanguage >> modelFromSource: aSource [

	^ JavaSmaCCProgramNodeImporterVisitor new parseCodeString: aSource
]
