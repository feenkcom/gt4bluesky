Class {
	#name : #BaselineOfGt4Bluesky,
	#superclass : #BaselineOf,
	#category : #BaselineOfGt4Bluesky
}

{ #category : #loading }
BaselineOfGt4Bluesky class >> loadLepiter [
	IceRepository registry  
		detect: [ :aRepository |
			aRepository name = 'gt4bluesky' ]
		ifFound: [ :aRepository | 
			| defaultDatabase currentProperties |
			defaultDatabase := LeDatabasesRegistry defaultLogicalDatabase.
			currentProperties := defaultDatabase properties.
			currentProperties addRegisteredDirectory: aRepository repositoryDirectory / 'lepiter'.
			defaultDatabase reload ]
		ifNone: [
			self inform: 'Repository not found.' ]
]

{ #category : #baseline }
BaselineOfGt4Bluesky >> baseline: spec [
	<baseline>
		^ spec for: #common do: [
			spec package: 'Gt4Bluesky'
		]
]
