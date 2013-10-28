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

  element :top_nav, css: '.top-nav' do
    return_object do |*links|
      links.collect { |link| browser_element.find(".#{link}") }
    end
  end
end

include Browser

browser.visit(GitHub)

page.sign_in.click

#page.login_form.forgot_password.click
puts page.top_nav('explore', 'features')