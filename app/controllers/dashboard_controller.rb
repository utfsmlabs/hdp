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
    @lista = JSON.parse(open(base_url+json_end).read)['issues']
    @lista.each do |issue|
      sub_url = "/"+issue['id'].to_s
      @extras = JSON.parse(open(issue_url+sub_url+json_end+incluir_changesets).read)['issue']['journals']
      issue['journals'] = @extras 
  end
end
