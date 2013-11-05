require_relative('lib/page_desc')

include PageDesc

class GitHub < Page
  url 'https://github.com'
  element :sign_in, css: '.signin' do
    after do
      browser.move_to(GitHubLogin)
    end
  end
end

class LoginForm < Section
  selector css: 'form[action="/session"]'

  element :forgot_password, css: 'a[href="/sessions/forgot_password"]'
end

class GitHubLogin < Page
  url 'https://github.com/login'

  element :login_form, LoginForm
end

include Browser

browser.visit(GitHub)

page.sign_in.click

puts page.login_form.attribute(:action)
#has_class
#text
#has_text?