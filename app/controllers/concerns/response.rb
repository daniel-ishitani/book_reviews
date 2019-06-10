module Response
    def json_response messages, success, data, status
        render json: {
            messages: messages,
            success: success,
            data: data
        }, status: status
    end
end