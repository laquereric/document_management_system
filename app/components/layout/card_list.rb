# Card list components for displaying collections of cards
module Layout
  module CardList
    # Alias for CardListComponent to maintain backward compatibility
    def self.new(*args, **kwargs)
      CardListComponent.new(*args, **kwargs)
    end
  end
end
