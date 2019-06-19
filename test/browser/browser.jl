using Test
using Headless.Browser
using Headless.Protocol: Runtime

@testset "browser open and close" begin
    @testset "free port" begin
         chrome = Browser.Chrome()
         @test process_running(chrome.process)
         Browser.close(chrome)
     end

    @testset "isportfree" begin
         chrome = Browser.Chrome()
         @test Browser.isportfree(9222) == false
         Browser.close(chrome)
     end

    @testset "used port" begin
         chrome = Browser.Chrome()
         @test_throws ErrorException("port already in use") Browser.Chrome()
         Browser.close(chrome)
     end
end


@testset "get_ws_urls" begin
    base = "ws://127.0.0.1/devtools/browser/"
    chrome = Browser.Chrome()
    urls = Browser.get_ws_urls(9222)
    Browser.close(chrome)
    @test length(urls) == 1
end

@testset "tab open and close" begin

    #Check that there is always a tab!

    @testset "can open new tabs" begin
        chrome = Browser.Chrome(headless=true)
        tab1 = Browser.newtab!(chrome, :tab2, "http://www.facebook.com")
        tab2 = Browser.newtab!(chrome, :tab3, "http://www.google.com")
        tab3 = Browser.newtab!(chrome, :tab4)
        @test istaskstarted(tab1.process)
        @test istaskstarted(tab2.process)
        @test istaskstarted(tab3.process)
        @test_throws AssertionError("tab already exists") Browser.newtab!(chrome,:tab2)
        Browser.close(chrome)
    end

    @testset "can close tabs" begin
        chrome = Browser.Chrome(headless=true)
        tab2 = Browser.newtab!(chrome, :tab2)
        Browser.closetab!(chrome, :tab2)
        @test istaskdone(tab2.process)
        @test length(chrome.tabs) == 1
        @test_throws ErrorException("tab doesn't exist") Browser.closetab!(chrome, :tab2)
        Browser.close(chrome)
    end

    @testset "activatetab!" begin
        chrome = Browser.Chrome(headless=false)
        tab2 = Browser.newtab!(chrome, :tab2)
        Browser.activatetab!(chrome, :tab1)
        Browser.close(chrome)
    end
end