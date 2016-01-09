require 'spec_helper'

describe Spree::Address do
  subject { build(:address, phone: '(11) 2334-4433') }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:number) }
    it { is_expected.to validate_presence_of(:district) }

    context 'phone' do
      it 'validates length of district' do
        subject.district = string_with_length(151)

        expect(subject).to_not be_valid
      end

      it 'validates number negative' do
        subject.number = -1

        expect(subject).to_not be_valid
      end
    end
  end

  context '#save' do
    before { subject.save! }

    it { is_expected.to be_persisted }
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

  context 'sanitize_phone' do
    it 'keeps only numbers' do
      subject.valid?

      expect(subject.phone).to eq('1123344433')
    end
  end

  def string_with_length(length)
    (1..length).map { (65 + rand(26)).chr }.join
  end
end