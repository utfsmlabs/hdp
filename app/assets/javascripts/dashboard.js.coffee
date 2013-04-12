# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

setInterval (do => @updateNetwork ), 300000

updateNetwork: () ->
  $('#red').attr("src","http://redes2.dcsc.utfsm.cl/mrtg/CORE/shaper/campus_santiago_sj_labs_inf-bytes-day.png")