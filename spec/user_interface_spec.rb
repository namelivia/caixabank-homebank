require_relative '../lib/user_interface'
describe UserInterface do
  it 'should autodetect and set locale' do
    allow(I18n).to receive_message_chain(:config,
                                         :available_locales=).with(%w(es en))
    allow(Locale).to receive_message_chain(:current, :language).and_return('en')
    allow(I18n).to receive(:locale=).with('en')
    i18n = double('I18n')
    allow(I18n).to receive(:load_path).and_return(i18n)
    expect(i18n).to receive(:<<)
    UserInterface.new.set_locale
  end

  it 'if the locale is not present use default' do
    allow(I18n).to receive_message_chain(:config,
                                         :available_locales=).with(%w(es en))
    allow(Locale).to receive_message_chain(:current, :language).and_return('invalid')
    allow(I18n).to receive(:locale=).with('invalid').and_raise
    allow(I18n).to receive(:default_locale).and_return('en')
    allow(I18n).to receive(:locale=).with('en')
    i18n = double('I18n')
    allow(I18n).to receive(:load_path).and_return(i18n)
    expect(i18n).to receive(:<<)
    UserInterface.new.set_locale
  end

  it 'should print a message' do
    message = 'foobar'
    allow($stdout).to receive(:puts).with(message)
    UserInterface.new.message(message)
  end

  it 'should print a localized message' do
    message = 'foobar'
    translated_message = 'barfoo'
    allow(I18n).to receive(:t).with('foobar').and_return(translated_message)
    allow($stdout).to receive(:puts).with(translated_message)
    UserInterface.new.localized_message(message)
  end

  it 'should read and strip input' do
    message = '   foobar '
    result = 'foobar'
    allow($stdin).to receive(:gets).and_return(message)

    expect(UserInterface.new.read_input).to eq(result)
  end

  it 'if the user confirms returns true' do
    question = 'yes or no?'
    result = true
    user_interface = UserInterface.new
    allow(user_interface).to receive(:localized_message).with(question)
    allow(user_interface).to receive(:localized_message).with(:confirm_or_deny)
    allow(user_interface).to receive(:read_input).and_return('y')
    allow(I18n).to receive(:t).with(:confirm_char).and_return('Y')
    expect(user_interface.user_confirms(question)).to eq(result)
  end

  it 'if the user denies  returns false' do
    question = 'yes or no?'
    result = false
    user_interface = UserInterface.new
    allow(user_interface).to receive(:localized_message).with(question)
    allow(user_interface).to receive(:localized_message).with(:confirm_or_deny)
    allow(user_interface).to receive(:read_input).and_return('n')
    allow(I18n).to receive(:t).with(:confirm_char).and_return('Y')
    allow(I18n).to receive(:t).with(:deny_char).and_return('N')
    expect(user_interface.user_confirms(question)).to eq(result)
  end
end
