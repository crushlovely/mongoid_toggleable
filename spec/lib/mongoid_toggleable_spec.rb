require 'spec_helper'

describe Mongoid::Toggleable do
  class Article
    include Mongoid::Document
    include Mongoid::Toggleable

    toggleable :visible, :inverse_scope_name => :hidden
  end

  class Product
    include Mongoid::Document
    include Mongoid::Toggleable

    toggleable :for_sale, :default => false
  end

  class Story
    include Mongoid::Document
    include Mongoid::Toggleable

    toggleable :publishable, :default => false, :inverse_scope_name => :unpublishable
    toggleable :featured, :default => true, :scope_name => :features
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

  describe 'dynamic scopes' do
    let!(:visible_article) { Article.create }
    let!(:hidden_article) { Article.create(:visible => false) }
    let!(:for_sale_product) { Product.create(:for_sale => true) }
    let!(:not_for_sale_product) { Product.create }

    describe 'scope definition' do
      it 'creates scopes based on the parameters passed in' do
        expect(Article).to respond_to(:visible)
        expect(Article).to respond_to(:hidden)
        expect(Product).to respond_to(:for_sale)
        expect(Product).to respond_to(:not_for_sale)
        expect(Story).to respond_to(:publishable)
        expect(Story).to respond_to(:unpublishable)
        expect(Story).to respond_to(:features)
        expect(Story).to respond_to(:not_featured)
      end
    end

    describe 'positive scope' do
      it 'returns the appropriate records' do
        expect(Article.visible).to include(visible_article)
        expect(Article.visible).not_to include(hidden_article)
        expect(Product.for_sale).to include(for_sale_product)
        expect(Product.for_sale).not_to include(not_for_sale_product)
      end
    end

    describe 'negative scope' do
      it 'returns the appropriate records' do
        expect(Article.hidden).to include(hidden_article)
        expect(Article.hidden).not_to include(visible_article)
        expect(Product.not_for_sale).to include(not_for_sale_product)
        expect(Product.not_for_sale).not_to include(for_sale_product)
      end
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
