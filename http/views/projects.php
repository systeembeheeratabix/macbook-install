<?=view('templates.header', ['title' => 'Projects'])?>

<div class="container">
    <h1>Projects</h1>
    <p>A list of all projects that have been automatically detected.</p>

    <div class="row">
    <?php foreach ($projects as $project) {
    ?>
        <div class="col-lg-3 col-md-4 col-sm-6">
            <div class="project">
                <a href="<?=$project['url']?>">
                    <img class="rounded" src="<?=$project['image']?>" alt="<?=$project['name']?>">
                </a>
                <h4><a href="<?=$project['url']?>"><?=$project['name']?></a></h4>
                <a href="javascript:openFinder('<?=$project['path']?>');"><img class="project-app-icon" src="/assets/images/finder.png" alt="Finder" title="Open in Finder"></a>
                <a href="vscode://file<?=$project['path']?>/"><img class="project-app-icon" src="/assets/images/vscode.png" alt="Visual Studio Code" title="Open in Visual Studio Code"></a>
            </div>
        </div>
    <?php
} ?>
    <div>
</div>

<script>
var openFinder = function(path) {
    $.ajax({
        method: 'POST',
        url: '/finder',
        data: {
            path: path
        }
    });
};
</script>

<?=view('templates.footer')?>
