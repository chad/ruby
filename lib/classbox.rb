class Classbox < Module
  def import_to(binding)
    @__overlayed_modules__.each do |klass, modules|
      modules.each do |mod|
        overlay_module(klass, mod, binding)
      end
    end
  end

  private

  def initialize
    super
    @__overlayed_modules__ = {}
  end

  @@__optimized_methods__ = [
    :+, :-, :*, :/, :%, :==, :===, :<, :<=, :<<, :[], :[]=, :>, :>=, :!, :!=,
    :length, :size, :succ
  ]

  def refine(klass, &block)
    mod = Module.new
    modules = @__overlayed_modules__[klass] ||= []
    modules.push(mod)
    overlay_module(klass, mod, binding(1))
    mod.singleton_class.send(:define_method, :method_added) do |mid|
      if @@__optimized_methods__.include?(mid)
        klass.send(:alias_method, :__original_optimized_method__, mid)
        klass.send(:define_method, mid) {}
        klass.send(:alias_method, mid, :__original_optimized_method__)
        klass.send(:remove_method, :__original_optimized_method__)
      end
    end
    mod.module_eval(&block)
  end
end

def classbox(name, &block)
  classbox = Classbox.new
  Object.const_set(name, classbox)
  classbox.module_eval(&block)
end

def import_classbox(classbox)
  classbox.import_to(binding(1))
end
