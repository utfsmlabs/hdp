#encoding: utf-8
class DashboardController < ApplicationController
  def index
    require 'open-uri'
    #Primos de Turno
    base_url = "http://ctm.inf.santiago.usm.cl/pdts"
    @pdts = open(base_url).read 
    #Code 
    base_url = "http://code.inf.santiago.usm.cl/projects/primos/issues"
    issue_url = "http://code.inf.santiago.usm.cl/issues"
    code_api = Settings.api_key.code #API KEY DASHBOARD USER
    json_end = ".json?key="+code_api+"&limit=11"
    incluir_changesets = "&include=changesets,journals"
    @tareas = JSON.parse(open(base_url+json_end).read)['issues']
    @tareas.each do |issue|
      sub_url = "/"+issue['id'].to_s
      @extras = JSON.parse(open(issue_url+sub_url+json_end+incluir_changesets).read)['issue']['journals']
      issue['journals'] = @extras 
    end
    #Frases
    require 'nokogiri'
    doc = Nokogiri::HTML(open('http://primos.inf.santiago.usm.cl/frases'))
    @frase = doc.css('.quote').children.text

    #Icinga
    url = "http://meru/icinga/cgi-bin/status.cgi?hostgroup=lds&hostgroup=lpa&style=overview&scroll=0&hoststatustypes=4&jsonoutput"
    @labs = JSON.parse(open(url,:http_basic_authentication=>['icingaadmin', Settings.api_key.icinga]).read)["status"]["hostgroup_overview"].flat_map{|group| group["members"]}.map{|host| host["host_name"]}

  end
end
