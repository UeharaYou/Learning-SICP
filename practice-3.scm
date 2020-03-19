;; SICP Practice: 3
;; Action - Effect Sheet

;; Principles: 
;; 0. Internal Properties shall be encapsulated by methods, which are later exposed via Unary Operations.
;; 1. Unary Operations might yields effects to itself (either groups or individuals). 
;; 2. Interations involing multiple participants (either groups or individuals) in order will yields effects to ALL participants simultanelously.
;; 3. Participants can group up to perform Actions, while Effects on a group could translate into effects to ALL group members.

;; Definitions: 
;; 1.     Participants: Objects which has its internal properties encapsulated by unary operators.
;; 1.1.   Individuals: Primitive Praticipants.
;; 1.2.   Groups: Concatenations of Members that act as a unified Participant.
;; 1.2.1. Members: Individuals or other groups satisfying relationships on the Grouping Hierarchy.
;; 2.     Interations: Operations taking a list of Participants as arguments and yield set of Interactions to another lists of Participants.
;; 2.1.   Unary Operations: Interactions taking a list of ONE participant inquiring or shifting its Internal Properties.
;; 2.2.   Actions: Interactions that will yield other Interactions.
;; 2.3.   Effects: Interactions yielded from other Interactions.

;; Constraints:
;; 1. Effects yielded from actions might take Participants unbound to the current environment, those from hypervisors for examples.
;; 2. 

;; DEAFT

Actions: Interactions that yields an Action <??> to super-lists of Participants or Effects to ALL participants.

Effects: Interactions that yields Effects to sub-lists of Participants.