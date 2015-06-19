Log.info("Loading note update performance improvement")

module Notes

  module ClassMethods


 def apply_notes(obj, json)
      if obj.note_dataset.first
    	association = self.association_reflection(:note)                                                                            
        SubnoteMetadata.join(:note, Sequel.qualify(:note, :id) => Sequel.qualify(:subnote_metadata, :note_id))                  
             .filter( association[:key] => obj.id  ).delete 
        obj.note_dataset.delete 
      end
      populate_persistent_ids(json)

      json.notes.each do |note|
        metadata, note = populate_metadata(note)

        publish = note['publish'] ? 1 : 0
        note.delete('publish')

        note_obj = Note.create(:notes_json_schema_version => json.class.schema_version,
                               :publish => publish,
                               :lock_version => 0,
                               :notes => JSON(note))

        metadata.each do |m|
          SubnoteMetadata.create(:publish => m.fetch(:publish),
                                 :note_id => note_obj.id,
                                 :guid => m.fetch(:guid))
        end

	note_obj.add_persistent_ids(extract_persistent_ids(note),
				     *obj.persistent_id_context)
        
        obj.add_note(note_obj)
      end
        
	obj
     end

  end
end

