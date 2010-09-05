require "classbox"

classbox :MyXMLFormat do
  refine Integer do
    def to_xml
      return to_xml_helper
    end

    private
     
    def to_xml_helper
      return to_s
    end
  end

  refine String do
    def to_xml
      return to_s
    end
  end

  refine Hash do
    def to_xml
      return inject("") { |s, (k, v)|
        s + "<#{k}>#{v.to_xml}</#{k}>"
      }
    end
  end

  def self.call_to_xml
    puts "to_xml in MyXMLFormat:"
    puts({:foo=>123,:bar=>"abc",:baz =>{:a=>1,:b=>2}}.to_xml)
  end
end

classbox :MyClassbox do
  import_classbox MyXMLFormat

  def self.call_to_xml
    puts "to_xml in MyClassbox:"
    puts({:foo=>123,:bar=>"abc",:baz =>{:a=>1,:b=>2}}.to_xml)
  end
end

module MyModule
  import_classbox MyXMLFormat

  def self.call_to_xml
    puts "to_xml in MyModule:"
    puts({:foo=>123,:bar=>"abc",:baz =>{:a=>1,:b=>2}}.to_xml)
  end
end

puts "to_xml in toplevel:"
puts({:foo=>123,:bar=>"abc",:baz =>{:a=>1,:b=>2}}.to_xml) rescue p($!)
MyXMLFormat.call_to_xml
MyClassbox.call_to_xml
MyModule.call_to_xml
