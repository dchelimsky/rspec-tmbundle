module Spec
  module DSL
    class BehaviourFactory
      BEHAVIOURS = {
        :default => Spec::DSL::Example,
        :shared => Spec::DSL::SharedBehaviour
      }      
      class << self
        # Registers a behaviour class +klass+ with the symbol
        # +type+. For example:
        #
        #   Spec::DSL::BehaviourFactory.register_behaviour(:farm, Spec::Farm::DSL::FarmBehaviour)
        #
        # This will cause Main#describe from a file living in 
        # <tt>spec/farm</tt> to create behaviour instances of type
        # Spec::Farm::DSL::FarmBehaviour.
        def register_behaviour(id, behaviour)
          BEHAVIOURS[id] = behaviour
        end

        def add_example_class(id, behaviour)
          warn "add_example_class is deprecated. Use register_behaviour instead."
          register_behaviour(id, behaviour)
        end
        def add_behaviour_class(id, behaviour)
          warn "add_behaviour_class is deprecated. Use register_behaviour instead."
          register_behaviour(id, behaviour)
        end
        
        def unregister_behaviour(id)
          BEHAVIOURS.delete(id)
        end

        def create(*args, &block)
          opts = Hash === args.last ? args.last : {}
          if opts[:shared]
            type = :shared
            return create_shared_module(*args, &block)
            
          # new: replaces behaviour_type  
          elsif opts[:type]
            type = opts[:type]
            
          #backwards compatibility
          elsif opts[:behaviour_type]
            type = opts[:behaviour_type]
            
          elsif opts[:spec_path] =~ /spec(\\|\/)(#{BEHAVIOURS.keys.join('|')})/
            type = $2.to_sym
          else
            type = :default
          end
          example_class = Class.new(BEHAVIOURS[type])
          example_class.describe(*args, &block)
        end

        protected
        def create_shared_module(*args, &block)
          BEHAVIOURS[:shared].new(*args, &block)
        end
      end
    end
  end
end
