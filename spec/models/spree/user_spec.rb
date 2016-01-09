require 'spec_helper'

describe Spree::User do
  def string_with_length(length)
    (1..length).map { (65 + rand(26)).chr }.join
  end

  subject(:user) { build(:user, phone: '(11) 2334-4433') }

  context 'validations' do
    it { is_expected.to validate_presence_of(:cpf)}
    it { is_expected.to validate_presence_of(:first_name)}
    it { is_expected.to validate_presence_of(:last_name)}
    it { is_expected.to validate_presence_of(:date_of_birth)}
    it { is_expected.to validate_presence_of(:phone)}

    context 'cpf' do
      it 'returns valid' do
        user.cpf = CPF.generate(true)

        expect(user).to be_valid
      end

      context 'when the length is incorrect' do
        it 'returns invalid' do
          user.cpf = '123456789'

          expect(user).to_not be_valid
        end
      end

      context 'when the number is incorrect' do
        it 'returns invalid' do
          user.cpf = '12345678910'

          expect(user).to_not be_valid
        end
      end
    end

    it 'validates length of first_name' do
      user.first_name = string_with_length(101)

      expect(user).to_not be_valid
    end

    it 'validates length of last_name' do
      user.last_name = string_with_length(101)

      expect(user).to_not be_valid
    end

    it 'validates date_of_birth is greater or equal to 18 years' do
      user.date_of_birth = 17.years.ago

      expect(user).to_not be_valid
    end
  end

  context '#full_name' do
    it 'should return first_name + last_name' do
      full_name = "#{user.first_name} #{user.last_name}"

      expect(user.full_name).to eq(full_name)
    end
  end

  context '#cpf_formatted' do
    it 'should return cpf formatted' do
      user.cpf = '12345678910'

      expect(user.cpf_formatted).to eql('123.456.789-10')
    end
  end

  it 'responds to extra properties' do
    expect(user).to respond_to :first_name, :last_name, :cpf, :date_of_birth, :phone, :alternative_phone
  end

  it 'saves user with success' do
    expect(user.save!).to be_truthy
  end

  context '#phone_area_code' do
    context 'when there is phone' do
      before { subject.valid? }

      it 'returns only the phone area code' do
        expect(subject.phone_area_code).to eq('11')
      end
    end

    context 'when there is not phone' do
      before { subject.phone = nil }

      it 'returns nil' do
        expect(subject.phone_area_code).to be_nil
      end
    end
  end

  context '#phone_number' do
    context 'when there is phone' do
      before { subject.valid? }

      it 'returns only the phone number' do
        expect(subject.phone_number).to eq('23344433')
      end
    end

    context 'when there is not phone' do
      before { subject.phone = nil }

      it 'returns nil' do
        expect(subject.phone_number).to be_nil
      end
    end
  end

  context 'sanitize' do
    context 'phone' do
      it 'keeps only numbers' do
        subject.valid?

        expect(subject.phone).to eq('1123344433')
      end
    end

    context 'cpf' do
      it 'keeps only number' do
        cpf_formatted = CPF.generate(true)
        user.cpf = cpf_formatted
        cpf = CPF.new(cpf_formatted)

        user.valid?

        expect(user.cpf).to eq(cpf.stripped)
      end
    end
  end
end
