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
	^ spec
		for: #common
		do: [ spec
				baseline: 'Gt4AtProto'
				with: [ spec repository: 'github://feenkcom/gt4atproto:main/src' ].
			spec package: 'Gt4Bluesky' with: [ spec requires: {'Gt4AtProto'} ] ]
]
