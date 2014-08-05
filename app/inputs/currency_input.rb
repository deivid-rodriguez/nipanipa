class CurrencyInput < SimpleForm::Inputs::Base
  def input(wrapper_options)
    input_html_classes.unshift("string")
    input_html_options[:value] = '0'

    "#{@builder.text_field(attribute_name, input_html_options)} $".html_safe
  end
end
