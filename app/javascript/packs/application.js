/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

// Styles
import 'styles/application'
import 'images/engineerssg-logo-text-desc.svg'

// JavaScript
import 'materialize-css'

import Rails from 'rails-ujs';
Rails.start();

import "blueimp-file-upload/js/vendor/jquery.ui.widget.js";
import "blueimp-file-upload/js/jquery.iframe-transport.js";
import "blueimp-file-upload/js/jquery.fileupload.js";
import "blueimp-file-upload/js/jquery.fileupload-image.js";


// Support component names relative to this directory:
let componentRequireContext = require.context("components", true)
import ReactRailsUJS from "react_ujs"
ReactRailsUJS.useContext(componentRequireContext)

$(document).ready(function(){
  $('.sidenav').sidenav();
  $('.tabs').tabs();

  $('.datepicker').datepicker();
  $('select').formSelect();

  $('#presentation_title').characterCounter();

  $('.presentation_upload_form').fileupload({
    dataType: 'json',
    replaceFileInput: false,
    url: $('.presentation_upload_form').attr('action'),
    add: function (e, data) {
      $(this).find('.upload-btn').removeClass('disabled');
      $(this).find('.file-path').removeClass('invalid');
      $(this).find('.upload-btn').click(function (e) {
        e.preventDefault();
        $(this).addClass('disabled');
        data.submit();
      });
    },
    progressall: function(e, data) {
      var progress = parseInt(data.loaded / data.total * 100, 10);
      $(this).find('.upload-progress-row').show();
      $(this).find('.determinate').css(
        'width',
        progress + '%'
      );
    },
    always: function (e, data) {
      $(this).find('.upload-progress-row').hide();
    },
    fail: function (e, data) {
      Materialize.toast(data.jqXHR.responseJSON.error, 10000);
      $(this).find('.file-path').addClass('invalid');
      $(this).find('.upload-btn').removeClass('disabled');
    },
    done: function (e, data) {
      $(this).find('.upload-btn').addClass('disabled');
      if ($('.presentation-new').length > 0) {
        window.location.href = "/presentations?status=notice&message=Upload+finished.";
      } else {
        $(this).find('.file-upload-row').hide();
        Materialize.toast('Upload finished.', 4000);
      }
    }
  });
});