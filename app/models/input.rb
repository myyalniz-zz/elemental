class Input < ActiveRecord::Base

    has_one :audio_selector
    accepts_nested_attributes_for :audio_selector, allow_destroy: true
    
    has_one :video_selector
    accepts_nested_attributes_for :video_selector, allow_destroy: true
    
    belongs_to :live_event
    
end
