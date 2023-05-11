Class {
	#name : #LeBlueskySnippet,
	#superclass : #LeSnippet,
	#instVars : [
		'jenkinsUrl'
	],
	#category : #'Gt4Bluesky-Model'
}

{ #category : #'api - accessing menu' }
LeBlueskySnippet class >> contextMenuItemSpecification [
	<leSnippetSpecification>
	^ LeContextMenuItemSpecification new
		snippetClass: self;
		title: 'Bluesky login'
]

{ #category : #accessing }
LeBlueskySnippet class >> empty [ 
	^ self new
]

{ #category : #accessing }
LeBlueskySnippet class >> leJsonV3AttributeMapping [
	^ super leJsonV3AttributeMapping
		yourself 
]

{ #category : #accessing }
LeBlueskySnippet class >> leJsonV3Name [
	^ 'blueskyLoginSnippet'
]

{ #category : #accessing }
LeBlueskySnippet class >> leJsonV4AttributeMapping [
	^ super leJsonV4AttributeMapping
		yourself 
]

{ #category : #accessing }
LeBlueskySnippet class >> leJsonV4Name [
	^ 'blueskyLoginSnippet'
]

{ #category : #accessing }
LeBlueskySnippet >> asSnippetViewModel [
	<return: #LeSnippetViewModel>
	^ LeBlueskySnippetViewModel new blueskySnippetModel: self
]

{ #category : #accessing }
LeBlueskySnippet >> contentAsString [
	<return: #String>
	^ String streamContents: [ :aStream | ]
]
