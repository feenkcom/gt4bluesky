Class {
	#name : #LeBlueskySnippet,
	#superclass : #LeTextualSnippet,
	#instVars : [
		'url',
		'text',
		'client',
		'actor'
	],
	#category : #'Gt4Bluesky-Snippet'
}

{ #category : #accessing }
LeBlueskySnippet class >> contextMenuItemSpefication [
	<leSnippetSpecification>
	^ LeContextMenuItemSpecification new
		snippetClass: self;
		title: 'Bluesky'
]

{ #category : #accessing }
LeBlueskySnippet class >> empty [
	"Return a content (page or block) with empty values (title or text).
	Required by ${method:LeContent>>#addBlockOfClass:after:}$"
	^ self new
]

{ #category : #accessing }
LeBlueskySnippet class >> leJsonV3AttributeMapping [

	^ super leJsonV3AttributeMapping
		add: (#url -> #urlString);
		add: (#text -> #textString);
		yourself
]

{ #category : #accessing }
LeBlueskySnippet class >> leJsonV3Name [
	^ 'blueskySnippet'
]

{ #category : #accessing }
LeBlueskySnippet class >> leJsonV4AttributeMapping [

	^ super leJsonV4AttributeMapping
		add: (#url -> #urlString);
		add: (#text -> #textString);
		yourself
]

{ #category : #accessing }
LeBlueskySnippet class >> leJsonV4Name [
	^ 'blueskySnippet'
]

{ #category : #accessing }
LeBlueskySnippet >> acceptVisitor: aVisitor [
	^ aVisitor visitBlueskySnippet: self
]

{ #category : #accessing }
LeBlueskySnippet >> actor [
	^ actor ifNil: [ actor := self client appBskyActorGetProfileActor: self client handle ]
]

{ #category : #accessing }
LeBlueskySnippet >> asSnippetViewModel [
	<return: #LeSnippetViewModel>
	^ LeBlueskySnippetViewModel new snippetModel: self
]

{ #category : #accessing }
LeBlueskySnippet >> client [
	^ client
]

{ #category : #accessing }
LeBlueskySnippet >> client: anObject [
	client := anObject.
	self announce: LeBlueskySnippetClientChanged new
]

{ #category : #accessing }
LeBlueskySnippet >> contentAsString [
	"Return a content, e.g., title or string.
	Required by ${method:LePageSummaryCardElement>>#summaryText}$"
	<return: #String>
	^ self url
]

{ #category : #accessing }
LeBlueskySnippet >> initialize [
	super initialize.
	url := ''.
	text := ''.
	client := GtApClient new
]

{ #category : #accessing }
LeBlueskySnippet >> text [
	^ text
]

{ #category : #accessing }
LeBlueskySnippet >> text: anObject [
	text := anObject
]

{ #category : #accessing }
LeBlueskySnippet >> url [
	^ url
]

{ #category : #accessing }
LeBlueskySnippet >> url: anObject [
	url := anObject
]