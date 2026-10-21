"
I am a baseline to define the structure and dependencies of the RitaMoose project.
"
Class {
	#name : 'BaselineOfRitaMoose',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfRitaMoose',
	#package : 'BaselineOfRitaMoose'
}

{ #category : 'baselines' }
BaselineOfRitaMoose >> baseline: spec [

	<baseline>
	spec for: #common do: [ "Dependencies"
			self gitProjectHealth: spec.

			"Packages"
			spec
				package: 'RitaMoose' with: [ spec requires: #( 'GitLabHealth' ) ];
				package: 'RitaMoose-Tests' with: [ spec requires: #( 'RitaMoose' ) ].

			"Groups"
			spec
				group: 'Core' with: #( 'RitaMoose' );
				group: 'Tests' with: #( 'RitaMoose-Tests' ) ]
]

{ #category : 'dependencies' }
BaselineOfRitaMoose >> gitProjectHealth: spec [

	spec baseline: 'GitLabHealth' with: [ spec repository: 'github://moosetechnology/GitProjectHealth:develop/src' ]
]

{ #category : 'accessing' }
BaselineOfRitaMoose >> projectClass [
	^ MetacelloCypressBaselineProject
]
