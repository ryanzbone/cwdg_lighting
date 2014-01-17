Slides = new Meteor.Collection("slides");

if (Meteor.isClient) {

  Template.controls.events({
    'click a#change-modes' : function() {
      $('#the-editor').toggle();
      $('#presentation').toggle();
      if ($('#change-modes').text() === 'Editor') {
        $('#change-modes').text('Presentation');
      } else {
        $('#change-modes').text('Editor');
      }
    }
  });

  Template.presentation.slides = function() {
    return Slides.find({}, {sort: { number: 1 } }).fetch();
  };

  slide_number = 1;
  previous_slide = '';
  Template.presentation.events({
    'click a#next' : function() {
      var current_slide = Slides.findOne({number: slide_number});
      if (current_slide !== undefined) {
        var slide_class = '.present-' + current_slide._id;
        $(previous_slide).toggle();
        $(slide_class).toggle();
        previous_slide = slide_class;
        slide_number += 1;
      } else {
        slide_number = 1;
      }
    }
  });

  Template.new_slide.events({
    'click a#new-slide' : function() {
      return Template.edit();
    }
  });

  Template.slide_display.slides = function() {
    return Slides.find({}, {sort: { number: 1 } }).fetch();
  };

  Template.slide_display.events({
    'click a.edit-link' : function() {
      var id = this._id;
      $('.md-display-' + id).toggle();
      $('.edit-' + id).toggle();
      $('.edit-' + id).find('.title-' + id).val(this.title);
      $('.edit-' + id).find('.number-' + id).val(this.number);
      $('.edit-' + id).find('.content-' + id).val(this.content);
    },

    'click a.delete-link' : function() {
      Slides.remove(this._id);
    },

    'click .save' : function() {
      var id = this._id;
      Slides.update(this._id, {title: $('.title-' + id).val(), content: $('.content-' + id).val(), number: parseInt($('.number-' + id).val())});
      $('.md-display-' + id).toggle();
      $('.edit-' + id).toggle();
    }
  });

  Template.slide_info.events({
    'click .submit' : function() {
      Slides.insert({title: $('#title').val(), content: $('#content').val(), number: parseInt($('#number').val())});
      $('#title').val('');
      $('#number').val('');
      $('#content').val('');
    }
  });

}

if (Meteor.isServer) {
  Meteor.startup(function () {
    // code to run on server at startup
  });
}
