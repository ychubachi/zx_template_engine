require 'pathname'

require 'openid'
require 'openid/extensions/sreg'
require 'openid/extensions/pape'
require 'openid/store/filesystem'
require 'openid/extensions/ax'

class ConsumerController < ApplicationController
  layout nil

  def index
    # render an openid form
  end

  def start
    begin
      identifier = params[:openid_identifier]
      if identifier.nil?
        flash[:error] = "Enter an OpenID identifier"
        redirect_to :action => 'index'
        return
      end
      oidreq = consumer.begin(identifier)
    rescue OpenID::OpenIDError => e
      flash[:error] = "Discovery failed for #{identifier}: #{e}"
      redirect_to :action => 'index'
      return
    end
    if params[:use_sreg]
      sregreq = OpenID::SReg::Request.new
      # required fields
      sregreq.request_fields(['email','nickname'], true)
      # optional fields
      sregreq.request_fields(['dob', 'fullname'], false)
      oidreq.add_extension(sregreq)
      oidreq.return_to_args['did_sreg'] = 'y'
    end
    if params[:use_pape]
      papereq = OpenID::PAPE::Request.new
      papereq.add_policy_uri(OpenID::PAPE::AUTH_PHISHING_RESISTANT)
      papereq.max_auth_age = 2*60*60
      oidreq.add_extension(papereq)
      oidreq.return_to_args['did_pape'] = 'y'
    end
    if params[:force_post]
      oidreq.return_to_args['force_post']='x'*2048
    end

    if params[:use_ax]	# added by yc
      # Thanks: http://d.hatena.ne.jp/a_kimura/20100407/1270660711
      ax = OpenID::AX::FetchRequest.new
      ax.add(OpenID::AX::AttrInfo.new('http://axschema.org/contact/email', 'email', true))
      ax.add(OpenID::AX::AttrInfo.new('http://axschema.org/namePerson/first', 'firstname', true))
      ax.add(OpenID::AX::AttrInfo.new('http://axschema.org/namePerson/last', 'lastname', true))
      oidreq.add_extension(ax)
      oidreq.return_to_args['did_ax'] = 'y'
    end

    return_to = url_for :action => 'complete', :only_path => false
    # realm = url_for :action => 'index', :id => nil, :only_path => false # <- DOSEN'T WORK 'not under trust_root'
    realm = return_to # by yc
    
    if oidreq.send_redirect?(realm, return_to, params[:immediate])
      redirect_to oidreq.redirect_url(realm, return_to, params[:immediate])
    else
      render :text => oidreq.html_markup(realm, return_to, params[:immediate], {'id' => 'openid_form'})
    end
  end

  def complete
    puts '-' * 60
    session['user'] = {}

    current_url = url_for(:action => 'complete', :only_path => false)
    parameters = params;		# by yc
    parameters.delete('controller');	# by yc
    parameters.delete('action');	# by yc
    oidresp = consumer.complete(parameters, current_url)
    case oidresp.status
    when OpenID::Consumer::FAILURE
      if oidresp.display_identifier
        flash[:error] = ("Verification of #{oidresp.display_identifier}"\
                         " failed: #{oidresp.message}")
      else
        flash[:error] = "Verification failed: #{oidresp.message}"
      end
      redirect_to :action => 'index'
    when OpenID::Consumer::SETUP_NEEDED
      flash[:alert] = "Immediate request failed - Setup Needed"
      redirect_to :action => 'index'
    when OpenID::Consumer::CANCEL
      flash[:alert] = "OpenID transaction cancelled."
      redirect_to :action => 'index'
    when OpenID::Consumer::SUCCESS
      identifier = oidresp.display_identifier

      sreg_resp = OpenID::SReg::Response.from_success_response(oidresp)
      email    = sreg_resp['email']
      nickname = sreg_resp['nickname']
      dob      = sreg_resp['dob']
      fullname = sreg_resp['fullname']

      ax_resp = OpenID::AX::FetchResponse.from_success_response(oidresp)
      if ax_resp && ax_resp.data
        email      = ax_resp.data['http://axschema.org/contact/email'][0]
        first_name = ax_resp.data['http://axschema.org/namePerson/first'][0]
        last_name  = ax_resp.data['http://axschema.org/namePerson/last'][0]
      end

      session['user'] = { :identifier => identifier,
        :email => email, :nickname => nickname, :dob => dob, :fullname => fullname,
        :first_name => first_name, :last_name => last_name
      };
      puts session['user'].to_s

      flash[:success] = ("Verification of #{oidresp.display_identifier}"\
                         " succeeded.")
      redirect_to :controller => 'home'
    else
      redirect_to :action => 'index'
    end
  end

  private

  def consumer
    if @consumer.nil?
      dir = Pathname.new(::Rails.root.to_s).join('db').join('cstore')
      store = OpenID::Store::Filesystem.new(dir)
      @consumer = OpenID::Consumer.new(session, store)
    end
    return @consumer
  end
end

