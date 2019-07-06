<?=view('templates.header', ['title' => 'Home'])?>

<style>
    .php img {
        width: 64px;
    }

    .php hr {
        width: 100%;
        background-color: #dee2e6;
        border: 0;
        height: 1px;
    }

    .php h1::after {
        border-bottom: 0;
        background-color: transparent;
    }

    .php h1.p {
        margin-top: 2rem;
    }

    .php .h img {
        margin-top: 1.6rem;
    }

    .php table, .php table tr th, .php table tr td {
        box-shadow: none;
        padding: .75rem;
        vertical-align: top;
        border: 0;
        border-top: 1px solid #dee2e6;
    }

    .php .center table {
        margin: 0 auto 4rem auto;
    }

    .php .h, .php .v, .php .e {
        background-color: transparent;
    }

    .php .center table {
        width: 100%;
    }

    .php td {
        border: 0;
    }
</style>

<div class="container php">
    <?php phpinfo() ?>
</div>

<?=view('templates.footer')?>
