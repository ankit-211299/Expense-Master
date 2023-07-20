# frozen_string_literal: true

module Admin
  class CategoriesController < ApplicationController
    before_action :set_category, only: %i[edit update destroy]

    def index
      @categories = Category.all
    end

    def create
      @category = Category.new(category_params)
      save_category_and_respond
    end

    def edit
      respond_to(&:js)
    end

    def update
      if @category.update(category_params)
        flash[:success] = 'Category updated successfully.'
      else
        flash[:danger] = 'Failed to update category.'
      end
      respond_to do |format|
        format.html { redirect_to admin_categories_path }
        format.js
      end
    end

    def destroy
      flash[:danger] = 'Category was successfully destroyed.' if @category.destroy
      respond_to(&:js)
    end

    private

    def set_category
      @category = Category.find(params[:id])
    end

    def category_params
      params.require(:category).permit(:name)
    end

    def save_category_and_respond
      respond_to do |format|
        if @category.save
          format.html { redirect_to admin_categories_path }
          format.js { flash[:success] = 'Category was successfully created.' }
        else
          flash[:danger] = 'Category could not be created.'
          format.html { redirect_to admin_categories_path }
          format.js {}
        end
      end
    end
  end
end
