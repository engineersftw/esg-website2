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

// Support component names relative to this directory:
let componentRequireContext = require.context("components", true)
import ReactRailsUJS from "react_ujs"
ReactRailsUJS.useContext(componentRequireContext)

document.addEventListener('DOMContentLoaded', () => {
    let elem = document.querySelector('.sidenav');
    M.Sidenav.init(elem);

    let el = document.querySelector('.tabs');
    M.Tabs.init(el);

    let datePickerElem = document.querySelector('.datepicker');
    M.Datepicker.init(datePickerElem);

    let anotherickerElem = document.querySelector('#event_end_datetime');
    M.Datepicker.init(anotherickerElem);

    let presentationTitle = document.querySelector('#presentation_title');
    M.CharacterCounter.init(presentationTitle);

    let selectElem = document.querySelector('select');
    M.FormSelect.init(selectElem);
})