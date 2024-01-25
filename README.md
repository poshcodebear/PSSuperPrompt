# PSSuperPrompt

Some cool extra tricks for your PowerShell prompt to display more details and colors

## Notes

- Yes, the code is a bit ugly; I've just tweaked with it here and there for a few years and
this is what I've come up with, but I've never taken the time to really make it look "spiffy".
- No, it does not have any configurable options. Sorry. Up until literally the moment I'm writing
this, it has always just run on my machines, so configurability for personal preference was
obviously not on my radar. I would love to add that, though, so if I get around to it, or if
someone likes this starting point and wants to shoot me a pull request with extra bells and
whistles, it may very well get those features in the future.
- The git functions require the module posh-git to be installed. It tests for this and will work
perfectly fine without it, you just won't get any git details in git repositories. It does use
a global to track that which I added because, at least on my machines, the module test was causing
my prompt to take multiple seconds to draw after every command; this way just tests once so you're
not getting the added delay every time.
- The Reset-Prompt function (and its alias 'rsp') is really just a way to make mucking with the
prompt easier so I don't have to reload every time I try something, or if I set up another prompt
it lets me switch back to this one with four keystrokes.
- To install it, just paste the entire thing into your `$profile`, or dot source the .ps1 file
from your `$profile`. Either will work.
- If I wind up taking the time, at some point I plan to add a better description and do a lot of the
cleanup and configurability stuff I mentioned above.
    - That said, I know myself too well; please don't hold your breath, as it could happen any time
    between now and the heat death of the universe, and probably closer to the latter than the
    former ;)
- The job control stuff I just added when I started this repo, and I haven't really used it much at all
since then, so it may or may not be all that great and functional. I just realized that I should be
making better use of jobs, and one of the problems with jobs is how invisible they are (you have to
remember they're there, and they never let you know when they're done), so the jobs piece is meant to
make them more visible.
- Fun fact: the original inspiration for this prompt is the Gentoo default prompts (both for root
and for regular users). It still somewhat resembles that prompt, though obviously heavily modified
at this point
