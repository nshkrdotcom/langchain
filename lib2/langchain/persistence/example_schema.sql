CREATE TABLE interactions (
    id SERIAL PRIMARY KEY,
    provider TEXT NOT NULL,
    model TEXT NOT NULL,
    request_timestamp TIMESTAMP WITH TIME ZONE NOT NULL,
    response_timestamp TIMESTAMP WITH TIME ZONE,
    request_data JSONB NOT NULL,
    response_data JSONB,
    error_data JSONB, -- Store error information if the request failed
    opts JSONB -- Store any additional options used
);

-- Add indexes as needed for efficient querying