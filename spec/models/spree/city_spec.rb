require 'spec_helper'

describe Spree::City do
  it { is_expected.to validate_presence_of(:state) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:ibge_code) }
end
