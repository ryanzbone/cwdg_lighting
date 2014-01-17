Slides = new Meteor.Collection("slides")

if Meteor.isClient

  Template.controls.events "click a#change-modes": ->
    $("#the-editor").toggle()
    $("#presentation").toggle()
    if $("#change-modes").text() is "Editor"
      $("#change-modes").text "Presentation"
    else
      $("#change-modes").text "Editor"

  Template.presentation.slides = ->
    Slides.find({},
      sort:
        number: 1
    ).fetch()

  slide_number = 1
  previous_slide = ""
  Template.presentation.events
    "click a#next": ->
      current_slide = Slides.findOne(number: slide_number)
      if current_slide isnt `undefined`
        slide_class = ".present-" + current_slide._id
        $(previous_slide).toggle()
        $(slide_class).toggle()
        previous_slide = slide_class
        slide_number += 1
      else
        slide_number = 1

    "click a#back": ->
      previous = Slides.findOne(number: slide_number - 1)
      current_slide = Slides.findOne(number: slide_number)
      if previous isnt `undefined`
        slide_class = ".present-" + previous._id
        $(previous_slide).toggle()
        $(slide_class).toggle()
        previous_slide = slide_class
        slide_number -= 1
      else
        slide_number = 1

  Template.new_slide.events "click a#new-slide": ->
    Template.edit()

  Template.slide_display.slides = ->
    Slides.find({},
      sort:
        number: 1
    ).fetch()

  Template.slide_display.events
    "click a.edit-link": ->
      id = @_id
      $(".md-display-" + id).toggle()
      $(".edit-" + id).toggle()
      $(".edit-" + id).find(".title-" + id).val @title
      $(".edit-" + id).find(".number-" + id).val @number
      $(".edit-" + id).find(".content-" + id).val @content
      false

    "click a.delete-link": ->
      Slides.remove @_id

    "click .save": ->
      id = @_id
      Slides.update @_id,
        title: $(".title-" + id).val()
        content: $(".content-" + id).val()
        number: parseInt($(".number-" + id).val())

      $(".md-display-" + id).toggle()
      $(".edit-" + id).toggle()

  Template.slide_info.events "click .submit": ->
    Slides.insert
      title: $("#title").val()
      content: $("#content").val()
      number: parseInt($("#number").val())

    $("#title").val ""
    $("#number").val ""
    $("#content").val ""
    false

if Meteor.isServer
  Meteor.startup ->
# code to run on server at startup
