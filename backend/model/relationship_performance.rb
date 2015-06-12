Log.info("Loading relationships update performance improvement")

module Relationships

  module ClassMethods

    # This notifies the current model that an instance of a related model has
    # been changed.  We respond by finding any of our own instances that refer
    # to the updated instance and update their mtime.
    def touch_mtime_of_anyone_related_to(obj)
      now = Time.now

      relationships.map do |relationship_defn|
        models = relationship_defn.participating_models

        if models.include?(obj.class)
          their_ref_columns = relationship_defn.reference_columns_for(obj.class)
          my_ref_columns = relationship_defn.reference_columns_for(self)
          their_ref_columns.each do |their_col|
            my_ref_columns.each do |my_col|

              # Example: if we're updating a subject record and want to update
              # the timestamps of any linked archival object records:
              #
              #  * self = ArchivalObject
              #  * relationship_defn is subject_rlshp
              #  * obj = #<Subject instance that was updated>
              #  * their_col = subject_rlshp.subject_id
              #  * my_col = subject_rlshp.archival_object_id

              self.join(relationship_defn, my_col => :id).
                filter(their_col => obj.id).
                update(Sequel.qualify(self.table_name, :system_mtime) => now)
            end
          end
        end
      end
    end
  end
end
