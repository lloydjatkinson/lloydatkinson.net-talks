---
# try also 'default' to start simple
theme: default
# random image from a curated Unsplash collection by Anthony
# like them? see https://unsplash.com/collections/94734566/slidev
# background: https://source.unsplash.com/collection/94734566/1920x1080
background: https://images.unsplash.com/photo-1571666521805-f5e8423aba9d
# apply any windi css classes to the current slide
class: 'text-center'
# https://sli.dev/custom/highlighters.html
highlighter: shiki
# show line numbers in code blocks
lineNumbers: false
# some information about the slides, markdown enabled
info: |
  ## Proposal Management FSM demo
  Proposal Management FSM demo

# persist drawings in exports and build
drawings:
  persist: true

download: true
---

# Proposal Management

> "How might we enhance the proposal management experience of sending, reviewing, updating and approving proposals"?

*Spoiler alert: workflows*

---
layout: image-right
image: https://images.unsplash.com/photo-1450101499163-c8848c66ca85

#class: text-center
---

# Background

My team is working on <span class="text-blue-600 font-bold">Proposal Management</span>

## Proposals

> A business proposal is sent from a supplier to a potential client for the purpose of winning a specific project. It is a written (paper or electronic) <span class="text-blue-600 font-bold">document</span> and it can either be requested by the client or sent unsolicited.

The keyword here being *document*.

---
layout: image-right
image: https://images.unsplash.com/photo-1596526131083-e8c633c948d2
---

# Informing stakeholders of proposal changes

Stakeholders may wish to update a proposal, anything from terms to the cost of provided services or dates of deliverables.

## Notifications

It's important to be able to notify stakeholders when that proposal document is updated.


---
layout: image-right
image: https://images.unsplash.com/photo-1457694587812-e8bf29a43845
---

## Ensuring that updates to a proposal document follow a defined procedure 

(organisation requirements, legal requirements, etc.)

Any document generally goes through *phases* such as:

* Being drafted
* Being reviewed
* Submitted to client

In some circumstances a document <span class="text-red-600 font-bold">should not</span> be updated once it's been submitted to a client <span class="text-blue-600 font-bold">until</span> they have reviewed it.

---
layout: image-right
image: https://images.unsplash.com/photo-1599508704512-2f19efd1e35f
---

## Notifications, enforcement of document requirements, preventing edits outside of key phases...

That could soon become complex and implementing these sorts of processes in software can often lead to "accidental complexity" and "technical debt".

---
layout: image-right
image: https://images.unsplash.com/photo-1531403009284-440f080d1e12
---

# A solution - workflows

> "the sequence of industrial, administrative, or other processes through which a piece of work passes from initiation to completion."

Let's break it down a little, we need:

* To send out notifications when a proposal document is updated
  * Do we want every type of edit to sent a notification or just key phases?
* Enforce a particular set of document guidelines we might be following
* Prevent invalid edits and updates occurring outside of specific phases in alignment with the guidelines.

---
layout: image-right
image: https://images.unsplash.com/photo-1517373116369-9bdb8cdc9f62
---

# How to implement a workflow?

### Answer: Finite State Machines

> A finite-state machine (FSM) or finite-state automaton (FSA, plural: automata), finite automaton, or simply a state machine, is a mathematical model of computation. It is an abstract machine that can be in exactly one of a finite number of states at any given time. The FSM can change from one state to another in response to some inputs; the change from one state to another is called a transition

FSM's are a "universal" concept that applies across multiple disciplines.

That sounds pretty scary. 😱

Let's explain it in simple terms...

---
layout: default
---

# Simply explained... designing robust software

One of the many huge benefits of FSM's

<img src="https://i.imgur.com/zEiQphw.png" class="w-100 mx-auto mt-16">

---
layout: default
---

# A hypothetical proposal document workflow

Time for a demo!

<img src="https://d33wubrfki0l68.cloudfront.net/72d0a3fe2fc56b8e38c5cb0fcbcd04515e615206/6ddd0/assets/blog/document-workflow-1-small.png" class="mx-auto">


---
layout: default
---

# An overview of the code

How this the diagram is implemented in code

```csharp {1|2|3|1-3}
machine.Configure(State.Review)
    .Permit(Triggers.ChangedNeeded, State.ChangesRequested)
    .Permit(Triggers.Submit, State.SubmittedToClient)
    .OnEntryAsync(OnReviewEntryAsync)
    .OnExitAsync(OnReviewExitAsync);

// other states and transitions continued...
```
<arrow v-click="3" x1="400" y1="400" x2="300" y2="175"  width="1" arrowSize="0" />

<arrow v-click="3" x1="570" y1="360" x2="220" y2="190"  width="1" arrowSize="0" />

<img src="https://i.imgur.com/360UE0o.png" class="mt-10 mx-auto h-48">

---
layout: default
---

# Keeping the domain design and code in sync

Keeping the domain experts/business analysts and the developers in sync via the power of finite state machines

Developers can make changes in accordance with new requirements and then assert that the code matches

On the left is the diagram created by hand and on the right is the output of the finite state machine library

<div class="flex">
  <img src="https://d33wubrfki0l68.cloudfront.net/72d0a3fe2fc56b8e38c5cb0fcbcd04515e615206/6ddd0/assets/blog/document-workflow-1-small.png" class="w-110">

  <img src="https://d33wubrfki0l68.cloudfront.net/c7b375c08fcf1af1ab7d2fdf1081a69419d7bb82/e089f/assets/blog/document-workflow-graphviz.svg" class="w-120 mt-16">
</div>

---
layout: default
---

# Auditing, event logs, integrations

Now that we've established how a workflow is designed with an FSM we can cover all of the "extra" benefits

* Every line of text in the screenshot can be plugged into some integration
  * Right now as you've seen SMS is one such integration
* Everything can be logged, audited, and tracked over time
 * Perfect for legal documents or simply finding out who updated the document and why
* Perfect for <span class="text-blue-600 font-bold">Event Driven Architecture</span> - every update can be published to a queue ("event bus")

<img src="https://i.imgur.com/NCPqec0.png" class="mx-auto">

---
layout: image
---

# Integration examples

<img src="https://flexie.io/wp-content/uploads/2017/08/zapier.png" class="mx-auto">

---
layout: default
---

# Improved maintainability and testing

We can go from code that looks like this that grows in complexity over time due to all the complex conditionals...

```csharp
if (document.IsInDraft)
{
    if (!document.HasBeenReviewedByLegal)
    {
        ...
    }
    else if (document.IsSentToCustomer && document.Approved || document.Rejected)
    {
        ...
    }
    ...
}
```

...to code that looks like this:

```csharp
  private async Task OnSubmittedToClientEnterAsync()
  {
      await notificationService.SendUpdateAsync(Priority.Verbose, "The proposal is now in the submitted to client stage. Great news!");
  }
```

---
layout: image-right
image: https://images.unsplash.com/photo-1591040092219-081fb773589c
---

# Conclusion

* Explained a part of what Proposal Management involves
* I devised a system that will allow us to model complex document workflows that can be changed easily when required
* Described how we can use integrations to inform stakeholders when changes have been made (SMS being one way)
* Gave examples of how we can use this across [company project name] via Event Driven Architecture


---
layout: image-right
image: https://images.unsplash.com/photo-1587440871875-191322ee64b0
---

# UX/UI

The existing Proposal Management software is a work in progress and based on outsourced development

* The UX and UI does not yet fully match [company project name]
* A requirement was to make it look *unique*
* I researched what other proposal software looks like in order to understand real world use cases...

[slides showing internal product removed]