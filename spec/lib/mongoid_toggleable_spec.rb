require 'spec_helper'

describe Mongoid::Toggleable do
  class Article
    include Mongoid::Document
    include Mongoid::Toggleable

    toggleable :visible
  end

  class Product
    include Mongoid::Document
    include Mongoid::Toggleable

    toggleable :for_sale, :default => false
  end

  class Story
    include Mongoid::Document
    include Mongoid::Toggleable

    toggleable :publishable, :default => false
    toggleable :featured, :default => true
  end

  describe 'field setup' do
    let(:article) { Article.new }
    let(:product) { Product.new }
    let(:story) { Story.new }

    it 'creates the right fields' do
      expect(article).to have_field(:visible).of_type(MongoidToggleable.boolean_type).with_default_value_of(true)
      expect(product).to have_field(:for_sale).of_type(MongoidToggleable.boolean_type).with_default_value_of(false)
      expect(story).to have_field(:publishable).of_type(MongoidToggleable.boolean_type).with_default_value_of(false)
      expect(story).to have_field(:featured).of_type(MongoidToggleable.boolean_type).with_default_value_of(true)
    end
  end

  describe '.find_toggleable' do
    let!(:visible_article) { Article.create }
    let!(:hidden_article) { Article.create(:visible => false) }

    it 'returns records based on the parameters passed in' do
      expect(Article.find_toggleable(:visible, true)).to include(visible_article)
      expect(Article.find_toggleable(:visible, true)).not_to include(hidden_article)
    end
  end

  describe '#toggle' do
    let(:visible_article) { Article.new }
    let(:hidden_article) { Article.new(:visible => false) }

    it 'toggles the value of the toggleable field' do
      expect { visible_article.toggle(:visible) }
        .to change { visible_article.visible }.from(true).to(false)
      expect { hidden_article.toggle(:visible) }
        .to change { hidden_article.visible }.from(false).to(true)
    end
  end

  describe '#toggle!' do
    let(:visible_article) { Article.create }
    let(:hidden_article) { Article.create(:visible => false) }

    it 'toggles the value of the toggleable field' do
      expect { visible_article.toggle!(:visible) }
        .to change { Article.find(visible_article.to_param).visible }.from(true).to(false)
      expect { hidden_article.toggle!(:visible) }
        .to change { Article.find(hidden_article.to_param).visible }.from(false).to(true)
    end
  end
end
