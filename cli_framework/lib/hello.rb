class Hello
  def run()
    Output.start(self.class.to_s, __method__)
    p 'Hello'
    Output.end(self.class.to_s, __method__)
  end
end