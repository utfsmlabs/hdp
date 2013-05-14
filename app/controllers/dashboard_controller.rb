#encoding: utf-8
require 'open-uri'
class DashboardController < ApplicationController
  def index
   
  end

  def primodeturno
    #Primos de Turno
    base_url = "http://ctm.inf.santiago.usm.cl/pdts"
    @pdts = open(base_url).read
    render 'dashboard/widgets/primos_de_turno',:layout=>false
  end

  def code
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
    render 'dashboard/widgets/tareas',:layout=>false
  end

  def frases
    #Frases
    require 'nokogiri'
    doc = Nokogiri::HTML(open('http://primos.inf.santiago.usm.cl/frases'))
    @frase = doc.css('.quote').children.text
    render 'dashboard/widgets/frases',:layout=>false
  end

  def icinga
    # Icinga
    url = "http://meru/icinga/cgi-bin/status.cgi?hostgroup=lds&hostgroup=lpa&style=overview&scroll=0&hoststatustypes=4&jsonoutput"
    @labs = JSON.parse(open(url,:http_basic_authentication=>['icingaadmin', Settings.api_key.icinga]).read)["status"]["hostgroup_overview"].flat_map{|group| group["members"]}.map{|host| host["host_name"]}
    render 'dashboard/widgets/icinga',:layout=>false
  end

  def icinga_servers

  end

  def twitter
    Twitter.configure do |config|
      config.consumer_key = Settings.twitter.consumer_key
      config.consumer_secret = Settings.twitter.consumer_secret
      config.oauth_token = Settings.twitter.oauth_token
      config.oauth_token_secret = Settings.twitter.oauth_token_secret
    end
    @tweets = Twitter.home_timeline
    render 'dashboard/widgets/twitter',:layout=>false
  end

end
