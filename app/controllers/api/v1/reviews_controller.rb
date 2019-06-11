class Api::V1::ReviewsController < ApplicationController
    before_action :load_book, only: :index
    before_action :load_review, only: [:show, :update, :destroy]
    before_action :authenticate_with_token!, only: [:create, :update, :destroy]

    def index
        @reviews = @book.reviews
        reviews_serializer = parse_json @reviews
        json_response "Indexed reviews successfully", true, {reviews: reviews_serializer}, :ok
    end

    def show
        review_serializer = parse_json @review
        json_response "Review found", true, {review: review_serializer}, :ok
    end

    def create
        review = Review.new(review_params)
        review.user_id = current_user.id
        review.book_id = params[:book_id]
        if review.save
            review_serializer = parse_json review
            json_response "Created review successfully", true, {review: review_serializer}, :ok
        else
            json_response "Failed to create review", false, {}, :unprocessable_entity
        end
    end

    def update
        if correct_user @review.user
            if @review.update(review_params)
                review_serializer = parse_json @review
                json_response "Updated review successfully", true, {review: review_serializer}, :ok
            else
                json_response "Failed to update", false, {}, :unprocessable_entity
            end
        else
            json_response "Unauthorized", false, {}, :unauthorized
        end
    end

    def destroy
        if correct_user @review.user
            if @review.destroy
                json_response "Deleted review successfully", true, {}, :ok
            else
                json_response "Failed to delete", false, {}, :unprocessable_entity
            end
        else
            json_response "Unauthorized", false, {}, :unauthorized
        end
    end

    private

    def load_book
        @book = Book.find_by(id: params[:book_id])
        unless @book.present?
            json_response "Cannot find the book", false, {}, :not_found
        end
    end

    def load_review
        @review = Review.find_by(id: params[:id])
        unless @review.present?
            json_response "Cannot find the review", false, {}, :not_found
        end
    end

    def review_params
        params.require(:review).permit(:title, :content_rating, :recommend_rating)
    end
end