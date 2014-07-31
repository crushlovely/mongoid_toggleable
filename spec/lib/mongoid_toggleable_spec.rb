require 'spec_helper'

describe Mongoid::Toggleable do
  class Article
    include Mongoid::Document
    include Mongoid::Toggleable

    toggleable :visible
  end

  describe 'field and index setup' do
    subject { Article.new }

    it 'has the right field' do
      expect(subject).to have_field(:visible).of_type(MongoidToggleable.boolean_type)
    end
  end
end
